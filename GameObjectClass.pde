class TransformType {
  public PVector Pos;
  public PVector Rot;
  public PVector Scale;

  public GameObjectClass Parent;
}

class GameObjectClass {
  private TransformType m_transform;
  private ColorType m_color = new ColorType(255, 0, 255, 255);
  private String m_nameIdentifier;
  private boolean m_renderingEnabled = true;
  // PImage or PShape depending on 2D or 3D

  public GameObjectClass(String name) {
    m_transform = new TransformType();
    m_nameIdentifier = name;
  }

  public void setPosition(float x, float y, float z) {
    m_transform.Pos = new PVector(x, y, z);
  }

  public void setRotation(float x, float y, float z) {
    m_transform.Rot = new PVector(x, y, z);
  }

  public void setScale(float x, float y, float z) {
    m_transform.Scale = new PVector(x, y, z);
  }

  public void setParent(GameObjectClass go) {
    m_transform.Parent = go;
  }

  public void frame() {
    // Meant to be overriden
  }

  public void render() {
    pushMatrix();
    fill(m_color.R, m_color.G, m_color.B, m_color.A);

    // Render gameobject by applying transform

    popMatrix();
  }
}
