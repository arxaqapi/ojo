# Ojo

**Ojo** is a simple utility that allows you to execute a specific command each time a certain file is being saved.

## Usage
Let's say you are sick the following pandoc command `pandoc --toc -s test.md -o test.html` each time you do some minor modifications.

**Ojo** Handles this for you, you just have to specify when to watch for modification and the command to execute and voilà !

```bash
ojo test.md -d 2 -x "pandoc --toc -s test.md -o test.html"
# or 
cargo run test/test.md -d 2 -x "pandoc --toc -s test/test.md -o test/test.html"
```

## To-do
- [ ] Implement a correct argument parser
- [ ] Implement correct error handling