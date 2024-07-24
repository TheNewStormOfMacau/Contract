.PHONY: install help generate compile

help:
	@echo "Usage:"
	@echo "  make install   - Install dependencies"
	@echo "  make generate  - Generate .go from .sol"
	@echo "                   requires jq and abigen to be installed and after compiled"
	@echo "                   example: make generate file=Token.sol"
	@echo "  make compile   - Compile solidity source code"
	
generate:
	@if [ -z "$(file)" ]; then \
		echo "Error: file is not set. Usage: make generate file=Token.sol"; \
		exit 1; \
	fi
	@contract_name=$$(basename $(file) .sol); \
	json_file=out/$$contract_name.sol/$$contract_name.json; \
	abi_file=out/$$contract_name.sol/$$contract_name.abi; \
	bin_file=out/$$contract_name.sol/$$contract_name.bin; \
	echo "Contract name: $$contract_name"; \
	echo "JSON file: $$json_file"; \
	echo "ABI file: $$abi_file"; \
	echo "BIN file: $$bin_file"; \
	jq .abi $$json_file > $$abi_file; \
	jq -r .bytecode.object $$json_file > $$bin_file; \
	echo "Generated $$abi_file and $$bin_file"; \
	abigen --abi $$abi_file --bin $$bin_file --pkg eth --out out/$$contract_name.sol/$$contract_name.go

compile:
	forge compile

install:
	forge install OpenZeppelin/openzeppelin-contracts;\
	forge install smartcontractkit/chainlink-brownie-contracts

clean:
	forge clean

remove:
	rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

update:
	forge update

build:
	forge build

test:
	forge test

	