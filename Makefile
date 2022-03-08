TM := $(shell date +%Y%m%d)

build:
	docker build \
		-t skopciewski/devenv-svelte:latest \
		--build-arg BUILDKIT_INLINE_CACHE=1 \
		--cache-from skopciewski/devenv-svelte:latest \
		.
.PHONY: build

push:
	docker push skopciewski/devenv-svelte:latest
	docker tag skopciewski/devenv-svelte:latest skopciewski/devenv-svelte:$(TM)
	docker push skopciewski/devenv-svelte:$(TM)
.PHONY: push

push_all:
	docker push skopciewski/devenv-svelte
.PHONY: push_all
