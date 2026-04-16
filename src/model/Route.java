package model;

public class Route {
    private int id;
    private String source;
    private String destination;
    private int distance;
    private String duration;

    // Constructors
    public Route() {
    }

    public Route(String source, String destination, int distance, String duration) {
        this.source = source;
        this.destination = destination;
        this.distance = distance;
        this.duration = duration;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public int getDistance() {
        return distance;
    }

    public void setDistance(int distance) {
        this.distance = distance;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    @Override
    public String toString() {
        return "Route [id=" + id + ", source=" + source + ", destination=" + destination + "]";
    }
}
