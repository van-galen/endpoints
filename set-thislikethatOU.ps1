# have a new machine that needs to live in the same place as an existing build in AD? 
# get existing OU, move the new object to the same place, yell results at console

function set-thislikethatOU {

  param($target,$template)

    $goods = get-adcomputer $template
  
    $thegoods = $goods.DistinguishedName -split "^[^,]*,",""

    get-adcomputer $target | move-adobject -TargetPath "$thegoods"

    write-host "moving $target to $thegoods"

    $results = get-adcomputer "$target"

    write-host -backgroundcolor magenta "CHECK MOVE: $results"

}
