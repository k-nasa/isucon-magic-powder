printf "\e[33m
==============================
install checking!
==============================\n
\e[m"

checking() {
  which $1 > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    printf "\e[32m [ok]   $1 \e[m\n"
  else
    printf "\e[31m [err]  $1 \e[m \n"
  fi
}

COMMANDS=(alp pt-query-digest htop)

for c in ${COMMANDS[@]}; do
    checking $c
done
