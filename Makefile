DOCKER_IMG = ryukinix/blog
MOUNT = \
    -v "$(PWD)/_posts:/app/_posts" \
	-v "$(PWD)/assets:/app/assets" \
	-v "$(PWD)/_sass:/app/_sass" \
	-v "$(PWD)/_includes:/app/_includes" \
	-v "$(PWD)/_layouts:/app/_layouts" \
	-v "$(PWD)/about:/app/about"

all: run

install-local:
	@if [ ! -d vendor ]; then \
		bundle install --path vendor/bundle; \
		bundle add jekyll; \
	fi

run: build
	docker run $(MOUNT) -it --rm --publish "4000:4000"  $(DOCKER_IMG)

build:
	docker build -t $(DOCKER_IMG) .

build-show:
	docker run -t $(DOCKER_IMG) build

run-local: install-local
	bundle exec jekyll serve

clean-local:
	rm -rfv _site vendor

deploy-test: build publish
	ssh starfox bash /home/lerax/Deploy/blog.sh

publish:
	docker push $(DOCKER_IMG)
