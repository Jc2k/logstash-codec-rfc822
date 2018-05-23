
build:
	docker build -t logstash-codec-rfc822 .

test: build
	docker run --rm -it logstash-codec-rfc822 bundle exec rspec
