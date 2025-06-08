package com.example.demo.dto;

public class Util {
	public static String jsReplace(String msg, String uri) {
		
		if (msg == null) {
			msg = "";
		}
		
		if (uri == null || uri.length() == 0) {
			uri = "/usr/home/main";
		}
		
		return String.format("""
					<script>
						const msg = '%s'.trim();
						
						if (msg.length > 0) {
							requestAnimationFrame(() => {
								alert(msg);
							})
						}
						
						setTimeout(() => {
							location.replace('%s');
						}, 100);
					</script>
				""", msg, uri);
	}
}