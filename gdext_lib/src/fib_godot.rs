use godot::prelude::*;

use crate::fib::fibonacci_reccursive;

#[derive(GodotClass)]
#[class(base=RefCounted, rename=_FibCalculator)]
pub struct FibCalculator {

}

#[godot_api]
impl FibCalculator {
  pub fn fib(n: i32) -> u64 {
    fibonacci_reccursive(n)
  }

  #[func]
  fn _fib(n: i32) -> u64 {
        Self::fib(n)
    }
}