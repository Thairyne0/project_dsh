import 'package:flutter/material.dart';
import '../../../utils/navigation_helper.util.dart';

/// ESEMPIO PRATICO: Come usare il sistema di Tab Navigation
///
/// Questo file mostra esempi concreti di come navigare tra i moduli
/// e le pagine dell'app mantenendo la sincronizzazione con l'URL

class NavigationExamplesWidget extends StatelessWidget {
  const NavigationExamplesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          title: '📱 Navigazione Base tra Tab',
          examples: [
            _ExampleCard(
              title: 'Vai a Dashboard',
              description: 'Naviga al tab Dashboard',
              onTap: () => ModularNavigation.toDashboard(context),
              codeExample: 'ModularNavigation.toDashboard(context);',
            ),
            _ExampleCard(
              title: 'Vai a News',
              description: 'Naviga al tab News (lista)',
              onTap: () => ModularNavigation.toNews(context),
              codeExample: 'ModularNavigation.toNews(context);',
            ),
            _ExampleCard(
              title: 'Vai a Eventi',
              description: 'Naviga al tab Eventi',
              onTap: () => ModularNavigation.toEvents(context),
              codeExample: 'ModularNavigation.toEvents(context);',
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: '🔍 Navigazione con Deep Linking',
          examples: [
            _ExampleCard(
              title: 'Dettaglio News',
              description: 'Apri news specifica (ID: 123)',
              onTap: () => ModularNavigation.toNewsDetail(context, '123'),
              codeExample: 'ModularNavigation.toNewsDetail(context, "123");',
              urlResult: '/news/123',
            ),
            _ExampleCard(
              title: 'Modifica Evento',
              description: 'Apri pagina edit evento (ID: abc)',
              onTap: () => ModularNavigation.toEditEvent(context, 'abc'),
              codeExample: 'ModularNavigation.toEditEvent(context, "abc");',
              urlResult: '/events/abc/edit',
            ),
            _ExampleCard(
              title: 'Crea News',
              description: 'Apri form per creare nuova news',
              onTap: () => ModularNavigation.toCreateNews(context),
              codeExample: 'ModularNavigation.toCreateNews(context);',
              urlResult: '/news/create',
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: '🎯 Navigazione Avanzata',
          examples: [
            _ExampleCard(
              title: 'Vai Indietro',
              description: 'Torna alla pagina precedente',
              onTap: () => ModularNavigation.back(context),
              codeExample: 'ModularNavigation.back(context);',
            ),
            _ExampleCard(
              title: 'Controlla se può tornare indietro',
              description: 'Utile per mostrare/nascondere il bottone back',
              onTap: () {
                final canGoBack = ModularNavigation.canGoBack(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Può tornare indietro: $canGoBack')),
                );
              },
              codeExample: 'bool canGoBack = ModularNavigation.canGoBack(context);',
            ),
            _ExampleCard(
              title: 'Ottieni Path Corrente',
              description: 'Mostra il path URL corrente',
              onTap: () {
                final currentPath = ModularNavigation.getCurrentPath(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Path corrente: $currentPath')),
                );
              },
              codeExample: 'String path = ModularNavigation.getCurrentPath(context);',
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: '⚙️ Navigazione con Parametri',
          examples: [
            _ExampleCard(
              title: 'Naviga con Query Params',
              description: 'Esempio: /events?category=sport&date=2026-02-17',
              onTap: () {
                ModularNavigation.goWithQueryParams(
                  context,
                  '/events',
                  queryParams: {
                    'category': 'sport',
                    'date': '2026-02-17',
                  },
                );
              },
              codeExample: '''ModularNavigation.goWithQueryParams(
  context,
  '/events',
  queryParams: {'category': 'sport', 'date': '2026-02-17'},
);''',
              urlResult: '/events?category=sport&date=2026-02-17',
            ),
            _ExampleCard(
              title: 'Naviga con Extra Data',
              description: 'Passa oggetti complessi tra pagine',
              onTap: () {
                ModularNavigation.goWithExtra(
                  context,
                  '/news',
                  extra: {'filterBy': 'recent', 'limit': 10},
                );
              },
              codeExample: '''ModularNavigation.goWithExtra(
  context,
  '/news',
  extra: {'filterBy': 'recent', 'limit': 10},
);''',
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildInfoBox(
          title: '💡 Best Practices',
          items: [
            '✅ Usa sempre ModularNavigation per navigare (non Navigator.push)',
            '✅ Ogni navigazione aggiorna automaticamente l\'URL',
            '✅ I tab si sincronizzano automaticamente con l\'URL',
            '✅ I deep link funzionano out-of-the-box',
            '✅ Il browser back/forward funziona correttamente',
          ],
        ),
        const SizedBox(height: 24),
        _buildInfoBox(
          title: '🎨 Cosa Succede Quando Navigo?',
          items: [
            '1. ModularNavigation chiama context.go(path)',
            '2. GoRouter aggiorna l\'URL del browser',
            '3. Il modulo corrispondente carica la pagina',
            '4. TabNavigationLayout legge l\'URL e seleziona il tab corretto',
            '5. L\'UI si aggiorna mostrando il tab attivo',
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> examples,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...examples,
      ],
    );
  }

  Widget _buildInfoBox({
    required String title,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade800,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  final String codeExample;
  final String? urlResult;

  const _ExampleCard({
    required this.title,
    required this.description,
    required this.onTap,
    required this.codeExample,
    this.urlResult,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  codeExample,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
              if (urlResult != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.link, size: 14, color: Colors.blue.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'URL: $urlResult',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

