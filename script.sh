# Проверка системы
IS_OPENVZ=
if hostnamectl status | grep -q openvz; then
	IS_OPENVZ=1
fi

if [[ $IS_OPENVZ ]]; then
	echo
	echo -e "Ваш хост окружение — ${green}OpenVZ${none}, которое не поддерживает развертывание на данном типе хоста. Пожалуйста, замените хост на ${green}KVM${none} и попробуйте снова."
	exit 0
fi

# Проверка пользователя
if [ `id -u` -eq 0 ];then
	echo -e "${blue}Проверка${none}..."
	echo
else
	echo -e "Текущий пользователь не является ${green}root${none}. Пожалуйста, переключитесь на пользователя ${green}root${none} или добавьте ${redBG}sudo${none} перед командой и повторите попытку."
	echo
	exit 0
fi

# Проверка прошивки
fwfile="./op.img.gz"
if [ -e $fwfile ];then
	echo -e "${blue}Развертывание${none}..."
	echo
	cp ./op.img.gz /
else
	echo -e "Пожалуйста, переименуйте файл прошивки в формате gz в ${green}op.img.gz${none} и загрузите его в текущую директорию, затем запустите этот скрипт снова."
	exit 0
fi

# Подготовка файлов
# Без проверки MD5
vps_kernel=$(uname -r)
wrt_kernel="wrt_kernel.bin"

wget --no-check-certificate https://raw.githubusercontent.com/esirplayground/VPS_OpenWrt/main/$wrt_kernel
cp $wrt_kernel /boot/vmlinuz-$vps_kernel

echo -e "${red}Перезагрузка${none}..."
reboot
