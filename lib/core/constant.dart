const notesTable = 'notes';
const sectionTable = 'sections';
const taskTable = 'tasks';


//notes table columns -ntc
const notesIdNTC = 'notesId';
const notesTitleNTC = 'notesTitle';
const createdAtNTC = 'createdAt';
const modifiedAtNTC = 'modifiedAt';
const notesContentHighLightNTC = 'notesContentHighLight';

//sections table columns -stc
const sectioonIdSTC = 'sectionId';
const notesIdSTC = 'notesId';
const sectionNoSTC = 'sectionNo';
const typeSTC = 'type';
const contentSTC = 'content';

//tasks table coumn ttc
const taskIdTTC = 'taskId';
const taskContentTTC = 'taskContent';
const completeStatusTTC = 'completeStatus';


const Map<int, String> months = {
  0: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'Septemeber',
  10: 'October',
  11: 'November',
  12: 'December',
};

DateTime getDateTime() {
  return DateTime.now();
}
