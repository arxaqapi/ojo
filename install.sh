bin_name="ojo"
install_path=".local/bin"

cargo build

if [ -f ~/${install_path}/${bin_name} ]; then
    echo "ojo already exists in" ${install_path}
    rm ~/${install_path}/${bin_name}
fi

cp target/debug/${bin_name} ~/${install_path}