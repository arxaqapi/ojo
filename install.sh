bin_name="ojo"
install_path=".local/bin"

# cargo build --release

if [ -f ~/${install_path}/${bin_name} ]; then
    echo "ojo already exists in" ${install_path}
    echo "the existing file will be overwritten"
    rm ~/${install_path}/${bin_name}
fi

cp target/release/${bin_name} ~/${install_path}