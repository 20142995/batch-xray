FROM ubuntu:18.04

RUN apt-get update && apt-get install -y  wget python3 python3-pip lrzsz curl unzip git chromium-browser
  
WORKDIR /root

RUN git clone https://github.com/20142995/batch-xray

WORKDIR /root/batch-xray

RUN pip3 install -r requirements.txt

RUN wget `curl https://api.github.com/repos/chaitin/xray/releases/latest | grep -o https://github.com/chaitin/xray/releases/download/[0-9]\.[0-9]\.[0-9]/xray_linux_amd64.zip` && \
  wget `curl https://api.github.com/repos/chaitin/rad/releases/latest | grep -o https://github.com/chaitin/rad/releases/download/[0-9]\.[0-9]/rad_linux_amd64.zip` && \
  unzip xray_linux_amd64.zip && unzip rad_linux_amd64.zip

RUN ./xray_linux_amd64  genca && cp ca.crt /usr/local/share/ca-certificates && update-ca-certificates

CMD ["bash"]  

