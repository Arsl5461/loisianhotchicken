import { toast } from 'sonner';

export interface ExportColumn<T> {
  header: string;
  value: (row: T) => string | number;
}

function toMatrix<T>(columns: ExportColumn<T>[], rows: T[]) {
  return {
    headers: columns.map((column) => column.header),
    data: rows.map((row) => columns.map((column) => column.value(row))),
  };
}

function download(fileName: string, blob: Blob) {
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = fileName;
  link.click();
  URL.revokeObjectURL(url);
}

function escapeXml(value: string | number) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

export function exportToExcel<T>(fileName: string, columns: ExportColumn<T>[], rows: T[]) {
  if (!rows.length) {
    toast.error('Nothing to export');
    return;
  }

  const { headers, data } = toMatrix(columns, rows);
  const headerRow = `<tr>${headers.map((header) => `<th>${escapeXml(header)}</th>`).join('')}</tr>`;
  const bodyRows = data
    .map((row) => `<tr>${row.map((cell) => `<td>${escapeXml(cell)}</td>`).join('')}</tr>`)
    .join('');
  const html = `<!DOCTYPE html><html><head><meta charset="UTF-8" /></head><body><table>${headerRow}${bodyRows}</table></body></html>`;
  download(
    `${fileName}.xls`,
    new Blob([html], { type: 'application/vnd.ms-excel;charset=utf-8' })
  );
  toast.success('Excel file downloaded');
}

export function exportToPdf<T>(fileName: string, title: string, columns: ExportColumn<T>[], rows: T[]) {
  if (!rows.length) {
    toast.error('Nothing to export');
    return;
  }

  const { headers, data } = toMatrix(columns, rows);
  const popup = window.open('', '_blank', 'width=1024,height=768');
  if (!popup) {
    toast.error('Allow popups to export PDF');
    return;
  }

  popup.document.write(`
    <html>
      <head>
        <title>${escapeXml(title)}</title>
        <style>
          body { font-family: Inter, Arial, sans-serif; padding: 24px; color: #1e1e1e; }
          h1 { font-size: 20px; margin-bottom: 16px; }
          table { width: 100%; border-collapse: collapse; font-size: 12px; }
          th { background: #A6190F; color: #fff; text-align: left; padding: 8px; }
          td { border-bottom: 1px solid #e5e7eb; padding: 8px; }
        </style>
      </head>
      <body>
        <h1>${escapeXml(title)}</h1>
        <table>
          <thead><tr>${headers.map((header) => `<th>${escapeXml(header)}</th>`).join('')}</tr></thead>
          <tbody>
            ${data.map((row) => `<tr>${row.map((cell) => `<td>${escapeXml(cell)}</td>`).join('')}</tr>`).join('')}
          </tbody>
        </table>
        <script>window.onload = function () { window.print(); }<\/script>
      </body>
    </html>
  `);
  popup.document.close();
  toast.success('Use the print dialog to save as PDF');
}
