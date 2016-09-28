/*******************************************************************************
 * 
 * inist-tools::proxy.pac
 * (inspiré du proxy.pac de l'INIST)
 * 
 * 
 ******************************************************************************/
 
function IsASubDomain(host, domain) {
  return (host.length >= domain.length && host.substring(host.length - domain.length) == domain);
}
 
function FindProxyForURL(url, host)
{
  if (dnsDomainIs(host, "dl.inist.fr")) return "PROXY proxyout.inist.fr:8080";

	if (dnsDomainIs(host, "vanilla.demo.inist.fr")) return "PROXY proxyout.inist.fr:8080";

  if (isPlainHostName(host) || 
      IsASubDomain(host, '.inist.fr') ||
      isInNet(host,"172.16.0.0","255.255.0.0") ||
	    isInNet(host,"192.168.0.0","255.255.0.0"))
      return "DIRECT";

	if (dnsDomainIs(host, "git.istex.fr")) return "DIRECT";

  if (isInNet(host,"127.0.0.0","255.0.0.0")) return "DIRECT";

  if (isPlainHostName(host) || IsASubDomain(host, '.couperin.org')) return "PROXY adsl.inist.fr:8080";

  if (isPlainHostName(host) || IsASubDomain(host, '.ortolang.fr')) return "PROXY adsl.inist.fr:8080";

  return "PROXY proxyout.inist.fr:8080";
}

