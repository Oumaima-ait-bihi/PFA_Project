import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { LineChart, Line, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { Smile, Moon, Heart, Lightbulb } from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';

const moodData = [
  { day: 'days.mon', value: 7 },
  { day: 'days.tue', value: 6 },
  { day: 'days.wed', value: 8 },
  { day: 'days.thu', value: 7 },
  { day: 'days.fri', value: 9 },
  { day: 'days.sat', value: 8 },
  { day: 'days.sun', value: 7 },
];

const sleepData = [
  { day: 'days.mon', hours: 7.5 },
  { day: 'days.tue', hours: 6.2 },
  { day: 'days.wed', hours: 8.1 },
  { day: 'days.thu', hours: 7.8 },
  { day: 'days.fri', hours: 6.5 },
  { day: 'days.sat', hours: 8.5 },
  { day: 'days.sun', hours: 7.9 },
];

const heartRateData = [
  { day: 'days.mon', bpm: 72 },
  { day: 'days.tue', bpm: 75 },
  { day: 'days.wed', bpm: 68 },
  { day: 'days.thu', bpm: 71 },
  { day: 'days.fri', bpm: 74 },
  { day: 'days.sat', bpm: 69 },
  { day: 'days.sun', bpm: 70 },
];

export function PatientDashboard() {
  const { t } = useLanguage();

  const CustomTooltip = ({ active, payload }: any) => {
    if (active && payload && payload.length) {
      return (
        <div className="bg-white border rounded-lg p-2 shadow-lg">
          <p className="text-sm">{payload[0].value}</p>
        </div>
      );
    }
    return null;
  };

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-white mb-2">{t('patient.welcome')}</h2>
        <p className="text-slate-600">{t('patient.week')}</p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
        {/* Mood Chart */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-amber-100">
                <Smile className="h-5 w-5 text-amber-600" />
              </div>
              <span>{t('patient.mood')}</span>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={200}>
              <LineChart data={moodData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                <XAxis 
                  dataKey="day" 
                  tick={{ fontSize: 12 }}
                  tickFormatter={(value) => t(value)}
                />
                <YAxis domain={[0, 10]} tick={{ fontSize: 12 }} />
                <Tooltip content={<CustomTooltip />} />
                <Line 
                  type="monotone" 
                  dataKey="value" 
                  stroke="#f59e0b" 
                  strokeWidth={3}
                  dot={{ fill: '#f59e0b', r: 4 }}
                />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Sleep Chart */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-purple-100">
                <Moon className="h-5 w-5 text-purple-600" />
              </div>
              <span>{t('patient.sleep')}</span>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={200}>
              <BarChart data={sleepData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                <XAxis 
                  dataKey="day" 
                  tick={{ fontSize: 12 }}
                  tickFormatter={(value) => t(value)}
                />
                <YAxis tick={{ fontSize: 12 }} />
                <Tooltip 
                  content={<CustomTooltip />}
                  formatter={(value) => [`${value} ${t('patient.hours')}`, '']}
                />
                <Bar dataKey="hours" fill="#9333ea" radius={[8, 8, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Heart Rate Chart */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-red-100">
                <Heart className="h-5 w-5 text-red-600" />
              </div>
              <span>{t('patient.rhythm')}</span>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={200}>
              <LineChart data={heartRateData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                <XAxis 
                  dataKey="day" 
                  tick={{ fontSize: 12 }}
                  tickFormatter={(value) => t(value)}
                />
                <YAxis domain={[60, 80]} tick={{ fontSize: 12 }} />
                <Tooltip 
                  content={<CustomTooltip />}
                  formatter={(value) => [`${value} ${t('patient.bpm')}`, '']}
                />
                <Line 
                  type="monotone" 
                  dataKey="bpm" 
                  stroke="#dc2626" 
                  strokeWidth={3}
                  dot={{ fill: '#dc2626', r: 4 }}
                />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>

      {/* Recommendations */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Lightbulb className="h-5 w-5 text-blue-600" />
            {t('patient.advice.title')}
          </CardTitle>
        </CardHeader>
        <CardContent>
          <ul className="space-y-3">
            {[1, 2, 3, 4].map((i) => (
              <li key={i} className="flex items-start gap-3">
                <div className="mt-1 h-2 w-2 rounded-full bg-blue-600" />
                <span className="text-slate-700">{t(`patient.advice.${i}`)}</span>
              </li>
            ))}
          </ul>
        </CardContent>
      </Card>
    </div>
  );
}
