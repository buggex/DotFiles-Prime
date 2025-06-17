-- List of aliases to block
local blocked_aliases = {
    ["Arctis Nova Pro Wireless:capture_MONO"] = true,
    ["Virtual-Mic:input_MONO"] = true,
}

port_om = ObjectManager { Interest { type = "port" } }
link_om = ObjectManager { Interest { type = "link" } }

-- Function to get port alias safely
local function get_port_alias(port_id)
    for port in port_om:iterate() do
        if port.properties["object.id"] == port_id then
            return port.properties["port.alias"]
        end
    end
    return nil
end

link_om:connect("object-added", function(_, link)
    local props = link.properties
    local output = props["link.output.port"]
    local input = props["link.input.port"]

    local out_alias = get_port_alias(output)
    local in_alias = get_port_alias(input)

    if blocked_aliases[out_alias] and blocked_aliases[in_alias] then
        -- Unfortunately there is not way to remove a link directly,
        -- with the current API, so we will just print a message.
    end
end)

link_om:activate()
port_om:activate()