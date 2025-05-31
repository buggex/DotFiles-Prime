function link_port(output_port, input_port)
    if not input_port or not output_port then
      return nil
    end

    local link_args = {
        ["link.input.node"] = input_port.properties["node.id"],
        ["link.input.port"] = input_port.properties["object.id"],

        ["link.output.node"] = output_port.properties["node.id"],
        ["link.output.port"] = output_port.properties["object.id"],

        ["object.id"] = nil,

        ["object.linger"] = true,

        ["node.description"] = "Link created by auto_connect_ports"
    }

    local link = Link("link-factory", link_args)
    link:activate(1)
    return link
end

function auto_link_ports(args)
    local input_constraint = args["input"]
    local output_constraint = args["output"]
    local connections = args["connect"]

    local input_om = ObjectManager {
        Interest {
            type = "port",
            input_constraint,
            Constraint {
                "port.direction", "equals", "in"
            }
        }
    }

    local output_om = ObjectManager {
        Interest {
            type = "port",
            output_constraint,
            Constraint {
                "port.direction", "equals", "out"
            }
        }
    }

    function _connect()
        --for output_name, input_name in pairs(connections) do
        for i = 1, #connections, 1 do
            local output_name = connections[i][1]
            local input_name = connections[i][2]

            local output = output_om:lookup {
                Constraint {
                    "audio.channel", "equals", output_name
                }
            }

            local input = input_om:lookup {
                Constraint {
                    "audio.channel", "equals", input_name
                }
            }
            
            link_port(output, input)
        end
    end

    output_om:connect("object-added", _connect)
    input_om:connect("object-added", _connect)
    
    output_om:activate()
    input_om:activate()
end

-- Sfx to System
auto_link_ports {
    output = Constraint { "port.alias", "matches", "Sfx:output*"},
    input = Constraint { "port.alias", "matches", "System:playback*"},
    connect = {
        {"MONO", "FL"},
        {"MONO", "FR"}
    }
}
