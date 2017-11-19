
# Gets the current module state from a Terraform state json file
# Parameters:
#   +tf_state_json+ - the terraform state represented as a json object
#
# returns the json node for the module's current state, nil if not available
def get_current_module_from_tf_state_json(tf_state_json)
  tf_state_json.modules.each { |tf_module|
    return tf_module if tf_module['path'].size == 2 and tf_module['path'][0] == 'root' and tf_module['path'][1] == 'it_minimal'
  }
  return nil
end