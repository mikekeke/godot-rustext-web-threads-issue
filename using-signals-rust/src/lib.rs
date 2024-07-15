use godot::prelude::*;
use std::sync::mpsc::{self, Receiver, Sender};

use std::thread; // TODO: ? is it correct way

struct MyExtension;

#[gdextension]
unsafe impl ExtensionLibrary for MyExtension {}

#[derive(GodotClass)]
#[class(base=Node, rename=_RustTestNode, init)]
pub struct RustTestNode {
    #[base]
    base: Base<Node>,

    receiver: Option<Receiver<String>>,
}

#[godot_api]
impl RustTestNode {
    #[signal]
    fn computation_done(n: String);

    #[func]
    fn test_signal(&mut self) -> () {
        self.base.emit_signal(
            "computation_done".into(),
            &[Variant::from("Rust node signal result")],
        );
    }

    pub fn get_test_str() -> String {
        "String from Rust node".to_string()
    }

    #[func]
    fn _get_test_str() -> String {
        Self::get_test_str()
    }

    #[func]
    fn _async_fib(&mut self, n: i32) -> () {
        let (sender, receiver): (Sender<String>, Receiver<String>) = mpsc::channel();
        self.receiver = Some(receiver);

        thread::spawn(move || {
            let res = Self::do_computation(n);
            sender.clone().send(res.to_string())
        });
    }

    #[func]
    fn _sync_fib(&mut self, n: i32) -> String {
        let result = Self::do_computation(n);
        let res_str = format!("Received from Rust sync call: {result}");
        res_str
    }

    pub fn do_computation(n: i32) -> u64 {
        // ! Do not use `godot_print` on code that called in Rust thread by web-export
        // ! it will throw some wtf `Godot engine not available` error
        // ! (works fine if not in Rust thread or in Rust thread but not web-export, tho)
        // godot_print!("Rust: do_computation");

        fibonacci_reccursive(n)
    }
}

#[godot_api]
impl INode for RustTestNode {
    fn process(&mut self, _delta: f64) {
        if let Some(rec) = &self.receiver {
            let res = rec.try_recv();
            match res {
                Ok(from_sender) => {
                    let res_str = format!("Received from the Rust thread: {from_sender}");
                    self.base
                        .emit_signal("computation_done".into(), &[Variant::from(res_str)]);
                }
                Err(_) => (),
            }
        }
    }
}

pub fn fibonacci_reccursive(n: i32) -> u64 {
    if n < 0 {
        panic!("{} is negative!", n);
    }
    match n {
        0 => panic!("zero is not a right argument to fibonacci_reccursive()!"),
        1 | 2 => 1,
        3 => 2,
        /*
        50    => 12586269025,
        */
        _ => fibonacci_reccursive(n - 1) + fibonacci_reccursive(n - 2),
    }
}
