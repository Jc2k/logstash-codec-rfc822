
build:
	docker build -t logstash-filter-rfc822 .

test: build
	docker run --rm -it logstash-filter-rfc822 bundle exec rspec
