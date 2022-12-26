bin_name="ojo"
install_path=".local/bin"

make

if [ -f ~/${install_path}/${bin_name} ]; then
    echo "ojo already exists here: " ${install_path}
    echo "the existing file will not be overwritten"
    exit 1
fi

cp bin/${bin_name} ~/${install_path}