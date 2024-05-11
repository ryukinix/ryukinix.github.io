DOCKER_IMG = ryukinix/blog

all: run

install-local:
	@if [ ! -d vendor ]; then \
		bundle install --path vendor/bundle; \
		bundle add jekyll; \
	fi

run: build
	docker run -it --rm --network=host $(DOCKER_IMG)

build:
	docker build -t $(DOCKER_IMG) .

run-local: install-deps
	bundle exec jekyll serve

clean-local:
	rm -rfv _site vendor
