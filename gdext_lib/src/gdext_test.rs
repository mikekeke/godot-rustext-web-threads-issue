use godot::prelude::*;

#[derive(GodotClass)]
#[class(base=RefCounted, init)]
pub struct TestClass {}

#[godot_api]
impl TestClass {

    // fn init() -> Self {
    //     Self{}
    // }

    pub fn get_int() -> u64 {
        42
    }

    #[func]
    fn _get_int() -> u64 {
        Self::get_int()
    }
}
