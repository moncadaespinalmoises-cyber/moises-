from flask import Flask, render_template, request, redirect, url_for, flash
import sqlite3
from pathlib import Path

app = Flask(__name__)
app.secret_key = "motostock_secret_key"

BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "database.db"


def get_db_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS productos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            codigo TEXT NOT NULL,
            nombre TEXT NOT NULL,
            categoria TEXT NOT NULL,
            marca TEXT NOT NULL,
            modelo_moto TEXT NOT NULL,
            precio_compra REAL NOT NULL,
            precio_venta REAL NOT NULL,
            stock INTEGER NOT NULL,
            stock_minimo INTEGER NOT NULL,
            descripcion TEXT
        )
    """)

    conn.commit()
    conn.close()


@app.route("/")
def login():
    return render_template("login.html")


@app.route("/ingresar", methods=["POST"])
def ingresar():
    correo = request.form.get("correo", "").strip()
    password = request.form.get("password", "").strip()

    if not correo or not password:
        flash("Debes completar correo y contraseña.")
        return redirect(url_for("login"))

    return redirect(url_for("dashboard"))


@app.route("/dashboard")
def dashboard():
    conn = get_db_connection()

    total_productos = conn.execute("SELECT COUNT(*) AS total FROM productos").fetchone()["total"]

    stock_bajo = conn.execute("""
        SELECT COUNT(*) AS total
        FROM productos
        WHERE stock <= stock_minimo
    """).fetchone()["total"]

    categorias = conn.execute("""
        SELECT COUNT(DISTINCT categoria) AS total
        FROM productos
    """).fetchone()["total"]

    valor_inventario = conn.execute("""
        SELECT COALESCE(SUM(stock * precio_venta), 0) AS total
        FROM productos
    """).fetchone()["total"]

    alertas_recientes = conn.execute("""
        SELECT *
        FROM productos
        WHERE stock <= stock_minimo
        ORDER BY stock ASC, nombre ASC
        LIMIT 5
    """).fetchall()

    productos_recientes = conn.execute("""
        SELECT *
        FROM productos
        ORDER BY id DESC
        LIMIT 5
    """).fetchall()

    conn.close()

    return render_template(
        "dashboard.html",
        total_productos=total_productos,
        stock_bajo=stock_bajo,
        categorias=categorias,
        valor_inventario=valor_inventario,
        alertas_recientes=alertas_recientes,
        productos_recientes=productos_recientes
    )


@app.route("/inventario")
def inventario():
    busqueda = request.args.get("q", "").strip()

    conn = get_db_connection()

    if busqueda:
        productos = conn.execute("""
            SELECT *
            FROM productos
            WHERE codigo LIKE ?
               OR nombre LIKE ?
               OR categoria LIKE ?
               OR marca LIKE ?
               OR modelo_moto LIKE ?
            ORDER BY id DESC
        """, (
            f"%{busqueda}%",
            f"%{busqueda}%",
            f"%{busqueda}%",
            f"%{busqueda}%",
            f"%{busqueda}%"
        )).fetchall()
    else:
        productos = conn.execute("""
            SELECT *
            FROM productos
            ORDER BY id DESC
        """).fetchall()

    conn.close()

    return render_template("inventario.html", productos=productos, busqueda=busqueda)


@app.route("/agregar-producto", methods=["GET", "POST"])
def agregar_producto():
    if request.method == "POST":
        codigo = request.form.get("codigo", "").strip()
        nombre = request.form.get("nombre", "").strip()
        categoria = request.form.get("categoria", "").strip()
        marca = request.form.get("marca", "").strip()
        modelo_moto = request.form.get("modelo_moto", "").strip()
        precio_compra = request.form.get("precio_compra", "").strip()
        precio_venta = request.form.get("precio_venta", "").strip()
        stock = request.form.get("stock", "").strip()
        stock_minimo = request.form.get("stock_minimo", "").strip()
        descripcion = request.form.get("descripcion", "").strip()

        if not all([codigo, nombre, categoria, marca, modelo_moto, precio_compra, precio_venta, stock, stock_minimo]):
            flash("Completa todos los campos obligatorios.")
            return redirect(url_for("agregar_producto"))

        try:
            precio_compra = float(precio_compra)
            precio_venta = float(precio_venta)
            stock = int(stock)
            stock_minimo = int(stock_minimo)
        except ValueError:
            flash("Revisa los números: precios, stock y stock mínimo.")
            return redirect(url_for("agregar_producto"))

        conn = get_db_connection()
        conn.execute("""
            INSERT INTO productos (
                codigo, nombre, categoria, marca, modelo_moto,
                precio_compra, precio_venta, stock, stock_minimo, descripcion
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            codigo, nombre, categoria, marca, modelo_moto,
            precio_compra, precio_venta, stock, stock_minimo, descripcion
        ))
        conn.commit()
        conn.close()

        flash("Producto agregado correctamente.")
        return redirect(url_for("inventario"))

    return render_template("agregar_producto.html")


@app.route("/alertas")
def alertas():
    conn = get_db_connection()
    productos_alerta = conn.execute("""
        SELECT *
        FROM productos
        WHERE stock <= stock_minimo
        ORDER BY stock ASC, nombre ASC
    """).fetchall()
    conn.close()

    return render_template("alertas.html", productos_alerta=productos_alerta)


@app.route("/eliminar-producto/<int:producto_id>", methods=["POST"])
def eliminar_producto(producto_id):
    conn = get_db_connection()
    conn.execute("DELETE FROM productos WHERE id = ?", (producto_id,))
    conn.commit()
    conn.close()

    flash("Producto eliminado correctamente.")
    return redirect(url_for("inventario"))


if __name__ == "__main__":
    init_db()
    app.run(debug=True)