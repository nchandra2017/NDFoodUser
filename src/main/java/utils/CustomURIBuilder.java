package utils;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

public class CustomURIBuilder {

    private String scheme;
    private String host;
    private int port;
    private String path;

    public CustomURIBuilder(String scheme, String host, int port, String path) {
        this.scheme = scheme;
        this.host = host;
        this.port = port;
        this.path = path;
    }

    public URL buildURL() throws MalformedURLException, URISyntaxException {
        // Use URI to safely construct the URL
        URI uri = new URI(scheme, null, host, port, path, null, null);
        return uri.toURL();
    }
}
