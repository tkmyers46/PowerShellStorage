#The Phone Registration system encrypts data at the web application, which then gets stored in the FIM Service database.

#The FIM Service then decrypts that data before using it to call the PhoneFactor web service.

 

#The certificate must be installed in these places:
#•Web Server [only the public key is required here]
#•FIM Server [the private key is required here]

#On both computers, the certificate must be installed in the LocalComputer\Personal store.

#To verify the permission on the certificate's private key, the following command can be used:
winhttpcertcfg -l -c LOCAL_MACHINE\My -s "<endpoint.domain.com>"
winhttpcertcfg -l -c TRMYE2012R2VM\administrator -s "<endpoint.domain.com>"
