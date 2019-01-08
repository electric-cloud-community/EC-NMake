
# Data that drives the create step picker registration for this plugin.
my %runNMake = (
    label       => "NMake - Run NMake",
    procedure   => "runNMake",
    description => "Integrates NMake Build framework into Electric Commander",
    category    => "Build"
);


$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Make - runMake");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/NMake");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/NMake - Run NMake");

@::createStepPickerSteps = (\%runNMake);