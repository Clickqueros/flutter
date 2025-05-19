import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 90, color: Colors.indigo),
              SizedBox(height: 20),
              Text("Iniciar Sesión", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Correo electrónico', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text("Iniciar Sesión"),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
              SizedBox(height: 20),
              Text("O ingresa con"),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: Icon(Icons.facebook, color: Colors.blue), onPressed: () {}),
                  IconButton(icon: Icon(Icons.g_mobiledata, color: Colors.red), onPressed: () {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inicio')),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context); // Cierra el drawer
                    },
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Inicio'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.work),
                title: Text('Servicios'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ServiciosScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Nosotros'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => NosotrosScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.mail),
                title: Text('Contacto'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ContactoScreen()));
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 250,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              viewportFraction: 1.0,
              enlargeCenterPage: false,
            ),
            items: [
              {
                'image': 'https://picsum.photos/1080/250',
                'title': 'Bienestar Mental',
                'subtitle': 'Comienza tu día con energía y propósito.',
              },
              {
                'image': 'https://picsum.photos/1080/250',
                'title': 'Meditación Guiada',
                'subtitle': 'Respira, relájate y encuentra tu paz interior.',
              },
              {
                'image': 'https://picsum.photos/1080/250',
                'title': 'Hábitos Saludables',
                'subtitle': 'Crea una rutina que transforme tu vida.',
              },
            ].map((item) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(item['image']!, fit: BoxFit.cover),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['title']!,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          item['subtitle']!,
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 150,
                  child: Image.network(
                    'https://picsum.photos/450/150',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 150,
                  child: Image.network(
                    'https://picsum.photos/450/150',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 150,
                  child: Image.network(
                    'https://picsum.photos/450/150',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Text('Contenido adicional debajo del banner', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiciosScreen extends StatelessWidget {
  final List<Map<String, String>> servicios = [
    {
      'titulo': 'Oatmeal Cookies',
      'categoria': 'Cookies',
      'imagen': 'https://picsum.photos/3000/200'
    },
    {
      'titulo': 'Triple Berry Smoothie',
      'categoria': 'Smoothies',
      'imagen': 'https://picsum.photos/3000/200'
    },
    {
      'titulo': 'Vegan Cookies',
      'categoria': 'Cookies',
      'imagen': 'https://picsum.photos/3000/200'
    },
    {
      'titulo': 'Pumpkin Spice Cookies',
      'categoria': 'Cookies',
      'imagen': 'https://picsum.photos/3000/200'
    },
    {
      'titulo': 'Brownies',
      'categoria': 'Postres',
      'imagen': 'https://picsum.photos/3000/200'
    },
    {
      'titulo': 'Perfect Fish',
      'categoria': 'Pescados',
      'imagen': 'https://picsum.photos/3000/200'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Servicios')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: servicios.map((servicio) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      servicio['imagen']!,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(servicio['titulo']!, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(servicio['categoria']!, style: TextStyle(color: Colors.grey[600])),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}


class NosotrosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nosotros')),
      body: Center(child: Text('Información sobre nosotros')),
    );
  }
}

class ContactoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacto')),
      body: Center(child: Text('Formulario o info de contacto')),
    );
  }
}

