#!/bin/bash

sudo apt update && sudo apt upgrade

sudo apt-get install unzip

sudo apt-get install sbsigntool

sudo apt-get install efitools

git clone https://github.com/hoaug-tran/Microsoft-certificates.git

mkdir ~/efikeys
cd efikeys

random_chars=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 4)

openssl req -new -x509 -newkey rsa:2048 -sha256 -days 3650 -nodes -subj "/CN=$random_chars PK Platform Key/" -keyout PK.key -out PK.pem

openssl req -new -x509 -newkey rsa:2048 -sha256 -days 3650 -nodes -subj "/CN=$random_chars KEK Exchange Key/" -keyout KEK.key -out KEK.pem

openssl req -new -x509 -newkey rsa:2048 -sha256 -days 3650 -nodes -subj "/CN=$random_chars ISK Image Signing Key/" -keyout ISK.key -out ISK.pem

chmod 0600 *.key

cp /home/$USER/Microsoft-certificates/MicCorUEFCA2011_2011-06-27.crt ~/efikeys/

cp /home/$USER/Microsoft-certificates/MicCorUEFCA2011_2011-06-27.crt ~/efikeys/

openssl x509 -in MicWinProPCA2011_2011-10-19.crt -inform DER -out MicWinProPCA2011_2011-10-19.pem -outform PEM

openssl x509 -in MicCorUEFCA2011_2011-06-27.crt -inform DER -out MicCorUEFCA2011_2011-06-27.pem -outform PEM

cert-to-efi-sig-list -g $(uuidgen) PK.pem PK.esl
cert-to-efi-sig-list -g $(uuidgen) KEK.pem KEK.esl
cert-to-efi-sig-list -g $(uuidgen) ISK.pem ISK.esl
cert-to-efi-sig-list -g $(uuidgen) MicWinProPCA2011_2011-10-19.pem MicWinProPCA2011_2011-10-19.esl
cert-to-efi-sig-list -g $(uuidgen) MicCorUEFCA2011_2011-06-27.pem MicCorUEFCA2011_2011-06-27.esl

cat ISK.esl MicWinProPCA2011_2011-10-19.esl MicCorUEFCA2011_2011-06-27.esl > db.esl

sign-efi-sig-list -k PK.key -c PK.pem PK PK.esl PK.auth

sign-efi-sig-list -k PK.key -c PK.pem KEK KEK.esl KEK.auth

sign-efi-sig-list -k KEK.key -c KEK.pem db db.esl db.auth

mkdir oc

cp ISK.key ISK.pem oc
cd oc

# Function to get the latest URL of OpenCorePkg release
_get_opencore_url() {
    local urlsource=$(curl -s "https://api.github.com/repos/acidanthera/OpenCorePkg/releases/latest" | grep "browser_download_url")
    local url=$(echo "$urlsource" | grep "RELEASE.zip" | head -n 1 | cut -d '"' -f 4)
    echo "$url"
}

# Function to get the latest URL of Opencore-Mod release
_get_opencore_mod_url() {
    local urlsource=$(curl -s "https://api.github.com/repos/wjz304/OpenCore_NO_ACPI_Build/releases/latest" | grep "browser_download_url")
    local url=$(echo "$urlsource" | grep "RELEASE.zip" | head -n 1 | cut -d '"' -f 4)
    echo "$url"
}

# Show menu
echo "Chon phien ban Opencore ban muon Sign:"
options=("OpenCorePkg" "Opencore-Mod")
select opt in "${options[@]}"
do
    case $opt in
        "OpenCorePkg")
            echo "Ban da chon Opencore"
            LINK=$(_get_opencore_url)
            break
            ;;
        "Opencore-Mod")
            echo "Ban da chon Opencore No ACPI"
            LINK=$(_get_opencore_mod_url)
            break
            ;;
        *) echo "Lua chon khong hop le. Vui long chon lai !";;
    esac
done

# Yêu cầu người dùng nhập phiên bản
echo "Nhap phien ban ( version ) cua Opencore / Opencore No ACPI:"
read VERSION

# Kiểm tra xem đường link có chứa "Opencore-Mod" hay không
if [[ $LINK == *"Opencore-Mod"* ]]; then
    echo "Opencore No ACPI"
    wget "$LINK"
    unzip "OpenCore-Mod-${VERSION}-RELEASE.zip" "X64/*" -d "./Downloaded"
    rm "OpenCore-Mod-${VERSION}-RELEASE.zip"
else
    echo "Opencore"
    wget "$LINK"
    unzip "OpenCore-${VERSION}-RELEASE.zip" "X64/*" -d "./Downloaded"
    rm "OpenCore-${VERSION}-RELEASE.zip"
fi

wget https://github.com/acidanthera/OcBinaryData/raw/master/Drivers/HfsPlus.efi -O ./Downloaded/X64/EFI/OC/Drivers/HfsPlus.efi

if [ -f "./ISK.key" ]; then
    echo "ISK.key was decrypted successfully"
fi

if [ -f "./ISK.pem" ]; then
    echo "ISK.pem was decrypted successfully"
fi

find ./Downloaded/X64/EFI/**/* -type f -name "*.efi" ! -name '.*' | cut -c 3- | xargs -I{} bash -c 'sbsign --key ISK.key --cert ISK.pem --output $(mkdir -p $(dirname "./Signed/{}") | echo "./Signed/{}") ./{}'

# Clean
rm -rf Downloaded
echo "Cleaned..."
echo "Thank you perez987, khronokernel, profzei, sakaki, Andrew Blitss and Ubuntu for your contributions to creating this automated command"
