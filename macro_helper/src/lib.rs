use proc_macro::TokenStream;

#[proc_macro_derive(HelloWorld)]
pub fn hello_world(_input: TokenStream) -> TokenStream {
    TokenStream::new()
}
