
function IsASubDomain(host, domain) {
    return (host.length >= domain.length &&
            host.substring(host.length - domain.length) == domain);
}
 
function FindProxyForURL(url, host)
{
	if (<?php echo trim(shell_exec("/sbin/ifconfig | grep -E '172.16.101.47|10.1.14'")) ? 1 : 0; ?>) {
		if (dnsDomainIs(host, "dl.inist.fr"))
	    return "PROXY proxyout.inist.fr:8080";

		if (dnsDomainIs(host, "vanilla.demo.inist.fr"))
	    return "PROXY proxyout.inist.fr:8080";

	  if (isPlainHostName(host) ||
	      IsASubDomain(host, '.inist.fr') ||
				isInNet(host,"172.16.0.0","255.255.0.0"))
	    return "DIRECT";

	  if (host == "localhost")
	    return "DIRECT";

	  if (isInNet(host,"127.0.0.0","255.0.0.0"))
	    return "DIRECT";

    //return "PROXY adsl.inist.fr:8080";
	  return "PROXY proxyout.inist.fr:8080";
	} else {
		return "DIRECT";
	}
}

// Pour tester :
/*
sudo apt-get install libpacparser1 python-pacparser libpacparser-dev
import pacparser
pacparser.init()
pacparser.parse_pac_file('/home/kerphi/services/proxy.pac')
pacparser.find_proxy('http://www.google.com', 'www.google.com')
pacparser.find_proxy('http://ida.intra.inist.fr', 'ida.intra.inist.fr')
pacparser.find_proxy('http://dl.inist.fr', 'dl.inist.fr')
pacparser.cleanup()
*/
