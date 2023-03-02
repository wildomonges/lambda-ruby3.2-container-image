FROM amazonlinux:latest

# Set ruby version to install
ARG RUBY_VERSION=3.2.1

# Define custom function directory
ARG FUNCTION_DIR="/function"

# Install dependencies
RUN yum install -y git gcc make readline-devel openssl-devel tar libyaml-devel rubygems ruby-devel

# Install rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Install ruby-build system-widely
RUN git clone https://github.com/rbenv/ruby-build.git /tmp/ruby-build
RUN cd /tmp/ruby-build && ./install.sh
RUN source ~/.bashrc && rbenv install --list && rbenv install ${RUBY_VERSION} && rbenv global ${RUBY_VERSION} && \
 gem install bundler && \ 
# Install the Runtime Interface Client 
 gem install aws_lambda_ric

# Give execution permission to on root folder where gems are installed
RUN chmod 777 /root 

# Set working directory
WORKDIR ${FUNCTION_DIR}

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ${FUNCTION_DIR}/
RUN source ~/.bashrc && bundle config set --local deployment 'true' && bundle install

# Copy layer codes
ADD lib ${FUNCTION_DIR}/lib

# Copy lambda function code
COPY hello_world/app.rb ${FUNCTION_DIR}/

# Call lambda runtime
ENTRYPOINT ["/root/.rbenv/shims/aws_lambda_ric"]

#CMD ["app.lambda_handler"]
