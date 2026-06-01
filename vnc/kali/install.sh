sudo docker build -t kali-vnc .

rm -rf ~/.kali
mkdir ~/.kali
sudo docker run -d -p 5901:5901 --name kali-vnc --network guac_guacnet  -v ~/.kali:/home/kali  kali-vnc 
