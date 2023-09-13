ifneq (,$(wildcard ./.env))
	include .env
	export
endif

cmd-exists-%:
	@hash $(*) > /dev/null 2>&1 || \
		(echo "ERROR: '$(*)' must be installed and available on your PATH."; exit 1)

.PHONY: lint-solidity
lint-solidity: cmd-exists-solhint
	@solhint $$(find contracts/src -name '*.sol')

.PHONY: lint-typescript
lint-typescript: cmd-exists-pnpm
	@pnpm run lint

.PHONY: lint
lint: lint-solidity lint-typescript

.PHONY: soldev
soldev:
	@./scripts/init-soldev.sh


