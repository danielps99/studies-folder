package br.com.bdws.show_port_number;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.server.servlet.context.ServletWebServerApplicationContext;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Objects;

@SpringBootApplication
@RestController
public class ShowPortNumberApplication {

	public static void main(String[] args) {
		SpringApplication.run(ShowPortNumberApplication.class, args);
	}

	@Autowired
	private ServletWebServerApplicationContext webServerAppCtxt;

    @GetMapping("/")
    public String getPort() {
        int port = Objects.requireNonNull(webServerAppCtxt.getWebServer()).getPort();
        return "Server is running on port: " + port;
    }
}
