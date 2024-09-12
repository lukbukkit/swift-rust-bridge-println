use std::backtrace::Backtrace;
use std::cell::Cell;

#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        type RustApp;

        #[swift_bridge(init)]
        fn new() -> RustApp;

        fn hello(&self) -> String;
    }
}

pub struct RustApp {}

// Smuggle backtrace for panic
// See: https://stackoverflow.com/a/73711057
thread_local! {
     static BACKTRACE: Cell<Option<Backtrace>> = const { Cell::new(None) };
}

impl RustApp {
    pub fn new() -> Self {
        RustApp {}
    }

    fn hello(&self) -> String {
        std::panic::set_hook(Box::new(|_info| {
            // Smuggle the backtrace
            let trace = Backtrace::force_capture();
            BACKTRACE.set(Some(trace));
        }));

        let result = std::panic::catch_unwind(||  {
            say_hello();
        });

        match result {
            Ok(_) => {"OK".to_string()},
            Err(err) => {
                let panic_message = match err.downcast::<String>() {
                    Ok(string) => {*string}
                    Err(panic) => {format!("Unknown type: {:?}", panic)}
                };

                // Get the backtrace
                let trace = BACKTRACE.take().unwrap();

                // Create error string
                format!("{}\n\n{}", panic_message, trace.to_string()).to_string()
            }
        }
    }
}
fn say_hello() {
    println!("Hello from Rust!");
}