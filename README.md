# Ojo

Ojo can watch a certain file and run a command.

## Usage
Let's say you wan't to perdiodically check if modifications occured in the file `test.md` and execute the corresponding pandoc command to obtain the wanted `test.html` file.

You simply would have to type the following command: 
```bash
ojo test.md -d 2 -x "pandoc --toc -s test.md -o test.html"
```