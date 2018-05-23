
build:
	docker build -t logstash-codec-rfc822 .

test: build
	docker run --rm -it logstash-codec-rfc822 bundle exec rspec

bake: build
	docker run --name logstash-codec-rfc822 -it logstash-codec-rfc822 bundle exec gem build logstash-codec-rfc822.gemspec
	docker cp logstash-codec-rfc822:/src/logstash-codec-rfc822-0.0.1.gem .
	docker rm -f logstash-codec-rfc822
