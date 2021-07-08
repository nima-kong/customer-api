package kongcd

default allow = false


allow {
  input["x-kong-plugin-key-auth"].enabled == true
  input["x-kong-plugin-opa"].enabled == true

}
