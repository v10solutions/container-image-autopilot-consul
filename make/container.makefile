#
# Container Image Autopilot Consul
#

.PHONY: container-run-linux
container-run-linux:
	$(BIN_DOCKER) compose -p "$(PROJ_NAME)" -f "$(PROJ_PLATFORM_OS)-compose.yml" up --no-start --scale "consul"="$(PROJ_SCALE)"
	for i in {1..$(PROJ_SCALE)}; \
	do \
		$(BIN_FIND) "bin" -mindepth "1" -type "f" -iname "*" -print0 \
		| $(BIN_TAR) -c --numeric-owner --owner "0" --group "0" -f "-" --null -T "-" \
		| $(BIN_DOCKER) compose -p "$(PROJ_NAME)" -f "$(PROJ_PLATFORM_OS)-compose.yml" cp --index "$${i}" "-" "consul":"/usr/local"; \
		$(BIN_FIND) "etc/doas.d" -mindepth "1" -type "f" -iname "*" -print0 \
		| $(BIN_TAR) -c --numeric-owner --owner "0" --group "0" -f "-" --null -T "-" \
		| $(BIN_DOCKER) compose -p "$(PROJ_NAME)" -f "$(PROJ_PLATFORM_OS)-compose.yml" cp --index "$${i}" "-" "consul":"/"; \
		$(BIN_FIND) "etc/containerpilot" -mindepth "1" -type "f" -iname "*" -print0 \
		| $(BIN_TAR) -c --numeric-owner --owner "0" --group "0" -f "-" --null -T "-" \
		| $(BIN_DOCKER) compose -p "$(PROJ_NAME)" -f "$(PROJ_PLATFORM_OS)-compose.yml" cp --index "$${i}" "-" "consul":"/usr/local"; \
		$(BIN_FIND) "etc/consul" -mindepth "1" -type "f" -iname "*" ! -iname "tls-key.pem" -print0 \
		| $(BIN_TAR) -c --numeric-owner --owner "0" --group "0" -f "-" --null -T "-" \
		| $(BIN_DOCKER) compose -p "$(PROJ_NAME)" -f "$(PROJ_PLATFORM_OS)-compose.yml" cp --index "$${i}" "-" "consul":"/usr/local"; \
		$(BIN_FIND) "etc/consul" -mindepth "1" -type "f" -iname "tls-key.pem" -print0 \
		| $(BIN_TAR) -c --numeric-owner --owner "480" --group "480" --mode "600" -f "-" --null -T "-" \
		| $(BIN_DOCKER) compose -p "$(PROJ_NAME)" -f "$(PROJ_PLATFORM_OS)-compose.yml" cp --index "$${i}" "-" "consul":"/usr/local"; \
	done
	$(BIN_DOCKER) compose -p "$(PROJ_NAME)" -f "$(PROJ_PLATFORM_OS)-compose.yml" start "consul"
	$(BIN_DOCKER) compose -p "$(PROJ_NAME)" -f "$(PROJ_PLATFORM_OS)-compose.yml" logs --no-log-prefix -f "consul" 2>&1 \
	| $(BIN_JQ) -R -r -C --unbuffered ". as \$$line | try fromjson catch \$$line"

.PHONY: container-run
container-run:
	$(MAKE) "container-run-$(PROJ_PLATFORM_OS)"

.PHONY: container-rm
container-rm:
	$(BIN_DOCKER) compose -f "$(PROJ_PLATFORM_OS)-compose.yml" rm -s -f "consul"
