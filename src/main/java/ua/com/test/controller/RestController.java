package ua.com.test.controller;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.io.IOException;

@org.springframework.web.bind.annotation.RestController
public class RestController {

    private static final String API_KEY = "AIzaSyA8G1V6ewWq_gMWVOmSLqoD4U9RGG-_-yo";

    @RequestMapping(value = "/find", method = RequestMethod.POST)
    public String find(@RequestBody String address) throws IOException {
        String link  = "https://maps.googleapis.com/maps/api/geocode/json?address=" +
                address.replace("=","")
                +"&key="
                +API_KEY;

        OkHttpClient client = new OkHttpClient();

        Request request = new Request.Builder()
                .url(link)
                .get()
                .addHeader("Cache-Control", "no-cache")
                .build();

        Response response = client.newCall(request).execute();

        JSONObject object = new JSONObject(response.body().string());
        JSONObject res = new JSONObject();
        JSONArray results = object.getJSONArray("results");
        for (int i = 0; i < results.length(); i++) {
            JSONObject jsonObject = results.getJSONObject(i);
            JSONObject arr = (JSONObject) jsonObject.get("geometry");
            res.put(jsonObject.getString("formatted_address"), arr.get("location"));
        }

        return res.toString();
    }
}
