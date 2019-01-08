# -------------------------------------------------------------------------
# Package
# mavenDriver.pl
#
# Dependencies
#    None
#
# Purpose
#    Execute nmake commands with Electric Commander
#
# Plugin Version
#    1.0
#
# Date
#    11/10/2010
#
# Engineer
#    Brian Nelson
#
# Copyright (c) 2010 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use strict;
use warnings;
$|=1;
use ElectricCommander;

#######################################################################
  # trim - deletes blank spaces before and after the entered value in 
  # the argument
  #
  # Arguments:
  #   -untrimmedString: string that will be trimmed
  #
  # Returns:
  #   trimmed string
  #
  ########################################################################  
  sub trim($) {
   
      my ($untrimmedString) = @_;
      
      my $string = $untrimmedString;
      
      #removes leading spaces
      $string =~ s/^\s+//;
      
      #removes trailing spaces
      $string =~ s/\s+$//;
      
      #returns trimmed string
      return $string;
  }


# -------------------------------------------------------------------------
# Variables
# -------------------------------------------------------------------------
my $ec = new ElectricCommander();
$ec->abortOnError(0);
  
$::gNMakeFile = trim($ec->getProperty("/myCall/file")-> findvalue("//value")->value());
$::gTarget = trim($ec->getProperty("/myCall/target")-> findvalue("//value")->value());
$::gWorkingDirectory = trim($ec->getProperty("/myCall/workingDirectory")-> findvalue("//value")->value());
$::gPOption = trim($ec->getProperty("/myCall/pOption")-> findvalue("//value")->value());
$::gAOption = trim($ec->getProperty("/myCall/aOption")-> findvalue("//value")->value());
$::gKOption = trim($ec->getProperty("/myCall/kOption")-> findvalue("//value")->value());
$::gCOption = trim($ec->getProperty("/myCall/cOption")-> findvalue("//value")->value());
$::gAdditionalOptions = trim($ec->getProperty("/myCall/additionalOptions")-> findvalue("//value")->value());


########################################################################
# main - contains the whole process to be done by the plugin, it builds 
#        the command line, sets the properties and the working directory
#
# Arguments:
#   -none

#
# Returns:
#   -nothing
#
########################################################################


sub main() {
    
    # create args array
    my @args = ();
    my %props;	


# if gPOption: add to command string
    if($::gPOption  && $::gPOption  ne "") {
        push(@args, "-P");
    }

# if $::gAOption: add to command string
    if($::gAOption   && $::gAOption  ne "") {
        push(@args, "-A");
    }

# if $::gKOption: add to command string
    if($::gKOption   && $::gKOption ne "") {
        push(@args, "-K");
    }

# if $::gCOption add to command string
    if($::gCOption   && $::gCOption ne "") {
        push(@args, "-C");
    }
#Additional options can be added to the nmake command
    if($::gAdditionalOptions  && $::gAdditionalOptions  ne "") {
        foreach my $command (split(' ',$::gAdditionalOptions)) {
            push(@args, $command);
        }
    }

 # if target: add to command string
    if($::gTarget && $::gTarget ne "") {
        foreach my $target (split(' ', $::gTarget)) {
             push(@args, $target);
         }
    }

 # if file: add to command string
    if($::gNMakeFile && $::gNMakeFile ne "") {
        push(@args,"-f $::gNMakeFile");
    }

    $props{"nMakeWorkingDir"} = "$::gWorkingDirectory";
    $props{"nmakeCommandLine"} = createNMakeCommandLine(\@args);
    setProperties(\%props);
}

########################################################################
# createNMakeCommandLine - creates the command line for the invocation
# of the program to be executed.
#
# Arguments:
#   -arr: array containing the command name and the arguments entered by 
#         the user in the UI
#
# Returns:
#   -the command line to be executed by the plugin
#
########################################################################

sub createNMakeCommandLine($) {

    my ($arr) = @_;

    my $command = "nmake /NOLOGO";

    foreach my $elem (@$arr) {
        $command .= " $elem";
    }
    
    return $command;
}

sub setProperties($) {
	
    my ($propHash) = @_;

    # get an EC object
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);

    foreach my $key (keys % $propHash) {
        my $val = $propHash->{$key};
        $ec->setProperty("/myCall/$key", $val);
    }
}

main();