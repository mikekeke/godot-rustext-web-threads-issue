use godot::prelude::*;

use crate::fib::fibonacci_reccursive;

#[derive(GodotClass)]
#[class(base=RefCounted, rename=_FibCalculator)]
pub struct FibCalculator {}

#[godot_api]
impl FibCalculator {
    pub fn slow_fib(n: i32) -> u64 {
        fibonacci_reccursive(n)
    }

    #[func]
    fn _slow_fib(n: i32) -> u64 {
        Self::slow_fib(n)
    }
}
