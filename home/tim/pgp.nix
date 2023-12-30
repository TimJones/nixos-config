{
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        # YubiKey
	trust = 5;
	text = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          mDMEYjJAIBYJKwYBBAHaRw8BAQdAS+zM/Xj6zY/bmwOKQNIujqqddP+EYf3FjHaf
          AjHydQO0JFRpbSBKb25lcyA8dGltLmpvbmVzQHNpZGVyb2xhYnMuY29tPoiWBBMW
          CAA+FiEEXXlk/y20Jqyzw1BaoqcC3Vton0UFAmIyQCACGwMFCQPCZwAFCwkIBwIG
          FQoJCAsCBBYCAwECHgECF4AACgkQoqcC3Vton0VxDAD+MoCcPC4rxiNAg/tKGccZ
          53IWfOMhVMUiipprGxk+5ZYBAI2Ie2aBcRowXNu+Zo6eVRw5K3jSW/+CFTFPYF98
          BWwPuDMEYjJAIBYJKwYBBAHaRw8BAQdA3Asbq/8jqNpMjjK3UHO80zECvTAYKIMT
          QocXVZst2I+IfgQYFggAJhYhBF15ZP8ttCass8NQWqKnAt1baJ9FBQJiMkAgAhsg
          BQkDwmcAAAoJEKKnAt1baJ9FOt8BAIH0IkKScNgGVCQaPMa3sJKzk3wOMMFBOLrC
          FUtoPU30AP0SxTba8Ho85lTBkFILnx1xbefynsBO8wlQnR8OaN2sDrg4BGIyQCAS
          CisGAQQBl1UBBQEBB0DJahvjx0Ck+ZVtvzGR3mC+q3OZ4jG0K2iU11M9RDQPMwMB
          CAeIfgQYFggAJhYhBF15ZP8ttCass8NQWqKnAt1baJ9FBQJiMkAgAhsMBQkDwmcA
          AAoJEKKnAt1baJ9FS6MBANhH9WoGfrSMoeAACQnZ8pNR6JSpiKd3fA3RCQO+uAuW
          AP9CD3EVssEsMtHS+Z/BN67xp6jYBnzFjsjWlAjjqU3oDQ==
          =Psd8
          -----END PGP PUBLIC KEY BLOCK-----
        '';
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    pinentryFlavor = "tty";
  };
}
