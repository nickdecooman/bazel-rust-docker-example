pub struct Greeter {
    greeting: String,
}

impl Greeter {
    pub fn new(greeting: &str) -> Greeter {
        Greeter {
            greeting: greeting.to_string(),
        }
    }

    pub fn greet(&self, name: &str) -> String {
        format!("{} {}!", &self.greeting, name)
    }
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_greeting() {
        let g = Greeter::new("Hello");
        assert_eq!(g.greet("World"), "Hello World!")
    }
}
