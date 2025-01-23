package ConfigFile;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class ConfigLoader {
    private static Properties properties = new Properties();

    static {
        try {
            String configFilePath = "C:/config/config.properties";
           

            FileInputStream fis = new FileInputStream(configFilePath);
            properties.load(fis);
            fis.close();

           
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to load configuration file.");
        }
    }

    public static String get(String key) {
        return properties.getProperty(key);
    }
}
