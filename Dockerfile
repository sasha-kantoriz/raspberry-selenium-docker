FROM ubuntu:21.10

RUN useradd -r selenium -s /bin/bash -m -d /opt/selenium
RUN apt update -y && apt install -y vim curl openjdk-8-jre gcc firefox
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
WORKDIR /opt/selenium
RUN curl -Lo selenium-server.jar 'https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.0.0/selenium-server-4.0.0.jar'
RUN curl -Lo geckodriver.tar.gz 'https://github.com/mozilla/geckodriver/archive/refs/tags/v0.30.0.tar.gz' && tar -xzf geckodriver.tar.gz
WORKDIR /opt/selenium/geckodriver-0.30.0
RUN . ~/.cargo/env && rustup target install armv7-unknown-linux-gnueabihf && \
    echo '. $HOME/.cargo/env' >> ~/.bashrc && \
    mkdir -p .cargo && touch .cargo/config && \
    echo '[target.armv7-unknown-linux-gnueabihf]\nlinker = "arm-linux-gnueabihf-gcc"' >> .cargo/config && \
    cargo build --release --target armv7-unknown-linux-gnueabihf && \
    ln -s /opt/selenium/geckodriver-0.30.0/target/armv7-unknown-linux-gnueabihf/release/geckodriver /usr/bin/geckodriver
WORKDIR /opt/selenium
USER selenium
CMD bash -c 'java -jar selenium-server.jar standalone --port 4444'
