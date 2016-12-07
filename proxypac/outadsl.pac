/*******************************************************************************
 * 
 * inist-tools::outadsl.pac
 * 
 * Permet d'utiliser la connexion ADSL de l'INIST
 * 
 * 
 ******************************************************************************/
 
function FindProxyForURL(url, host)
{
        return "PROXY adsl.inist.fr:8080";
}
