# Ojo

> 🚧 **Disclaimer:** This tool is still under heavy development and major changes in it's usage are still possible
 

**Ojo** is a simple CLI tool that allows you to execute a specific command each time the specified file or directory is being modified.

## Usage
Let's say that you are sick of running the following pandoc command `pandoc --toc -s test.md -o test.html` each time you do some minor modifications to your `test.md` file.

**Ojo** automates the command execution by specifying a file that is being watched and the command to be run each time the watched file is modified.

Specify the file and the command as shown below and voilà!

```bash
ojo test/test.md -x "pandoc --toc -s test/test.md -o test/test.html" 
```
> You can also specify how frequently **ojo** should look for updates with the optional `[-d delay]` parameter.