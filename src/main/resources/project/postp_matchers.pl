use ElectricCommander;

push (@::gMatchers,
  {
        id =>          "NmakeError",
        pattern =>     q{.+ error(.+)},
        action =>           q{
                              
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');

                              $desc .= "Error: $1 ";
                                
                               setProperty("summary", $desc . "\n");
                              
                             },
  },
);



