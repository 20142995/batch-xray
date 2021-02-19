FROM ubuntu:18.04

RUN apt-get update && \
  apt-get install -y gnupg2 wget python3 python3-pip lrzsz curl unzip git && \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && apt-get install -y google-chrome-stable && rm -rf /var/lib/apt/lists/*
  
WORKDIR /root

RUN git clone https://github.com/20142995/batch-xray

WORKDIR /root/batch-xray

RUN pip install -r requirements.txt

RUN wget `curl https://api.github.com/repos/chaitin/xray/releases/latest | grep -o https://github.com/chaitin/xray/releases/download/[0-9]\.[0-9]\.[0-9]/xray_linux_amd64.zip` && \
  wget `curl https://api.github.com/repos/chaitin/rad/releases/latest | grep -o https://github.com/chaitin/rad/releases/download/[0-9]\.[0-9]/rad_linux_amd64.zip` && \
  unzip xray_linux_amd64.zip && unzip rad_linux_amd64.zip

RUN ./xray_linux_amd64  genca && cp ca.crt /usr/local/share/ca-certificates && update-ca-certificates

CMD ["bash"]

